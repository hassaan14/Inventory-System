class TransactionsController < ApplicationController
  before_action :find_user_product

    def index
      @transactions = @user.transactions.order(created_at: :desc).page(params[:page]).per(5)
      filter_transactions_by_date(params[:start_date], params[:end_date]) if params[:start_date].present? && params[:end_date].present?
    end
    
  def show
    @transaction = Transaction.find(params[:id])
    calculate_profit
  end
  
  def new
    @transaction = Transaction.new
    @product_names = @user.products.pluck(:item_name).uniq
    @product_names_description = @user.products.where(item_name: @product.item_name).pluck(:description).uniq
  end

  def create
    transaction_type = params[:transaction][:transaction_type]
    @product_names = @user.products.pluck(:item_name).uniq
    @product_names_description = Product.where(item_name: @product.item_name).pluck(:description).uniq
    stock = params[:transaction][:stock].to_i
    price = params[:transaction][:price].to_f
    selected_brand = params[:transaction][:brand]
    selected_description = params[:transaction][:description]
  
    @product.stock ||= 0 
    
    if transaction_type == "buy"
      existing_product = @user.products.find_by(item_name: @product.item_name,  brand: selected_brand, description: selected_description, price: price )
  
      if existing_product
        existing_product.stock += stock
        existing_product.save
      else
        @product = Product.new(
          item_name: @product.item_name,
          brand: selected_brand,
          stock: stock,
          price: price,
          description: selected_description,
          user: @user
        )
        @product.save
      end
    elsif transaction_type == "sell"
      existing_product = @user.products.find_by(
        item_name: @product.item_name,
        brand: selected_brand,
        description: selected_description
      )
    
      if existing_product && existing_product.stock >= stock
        existing_product.stock -= stock
        existing_product.save
        if existing_product.stock == 0
          existing_product.destroy
        else
          # existing_product.save
        end
      else
        flash[:alert] = "Transaction failed. Not enough stock or product not found."
        render :new and return
      end
    end    
  
    @transaction = @product.transactions.build(transaction_params)
  
    if @transaction.save
      redirect_to product_transactions_path(@product), notice: "Transaction was successful."
    else
      flash[:alert] = "Transaction failed."
      render :new
    end
  end
  
def edit
  @transaction = Transaction.find(params[:id])
  @product_names = @transaction.product.user.products.pluck(:item_name).uniq
  @product_names_description = @product.class.where(item_name: @transaction.product.item_name).pluck(:description).uniq
end

def update
  @transaction = Transaction.find(params[:id])
  if @transaction.update(transaction_params)
    redirect_to product_transaction_path(@product, @transaction)
  else
    render :edit, status: :unprocessable_entity
  end
end

def destroy
  @transaction = Transaction.find(params[:id])
  @transaction.destroy
  redirect_to product_transactions_path(@product), status: :see_other
end

private
def transaction_params
  params.require(:transaction).permit(:transaction_type, :price, :stock, :brand, :product_id)
end

  def find_user_product
    @user = current_user
    @product = Product.find(params[:product_id])
  end 
  
  def calculate_profit
    if @transaction&.transaction_type == 'sell'
      
        buy_price = @product.transactions.where(transaction_type: 'buy').last&.price
        sell_price = @transaction.price
        if sell_price.present? && buy_price.present?
          @profit = sell_price - buy_price
        else
          @profit = 0.0
        end
        @transaction.save
    end
end
  
  def filter_transactions_by_date(start_date, end_date)
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)

    @transactions = @transactions.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
  end
end
