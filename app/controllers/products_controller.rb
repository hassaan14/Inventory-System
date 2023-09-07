class ProductsController < ApplicationController
before_action :find_user

def index 
  @q = Product.ransack(params[:q])
  @products = @q.result(distinct: true).page(params[:page])

  if @q.result.empty?
    flash.now[:notice] = "Product does not Exist."
    @products = []
  end
end

def show
    @product = Product.find(params[:id])
    @transactions = @product.transactions.order(created_at: :desc)
    @related_products = @user.products.where(item_name: @product.item_name).page(params[:page]).per(10) 
end

def new 
    @product = Product.new
end

def create
  @product = @user.products.new(product_params)
  @transaction = @product.transactions.build(transaction_type: 'buy', price: @product.price, stock: @product.stock, brand: @product.brand)
  
  if @product.save && @transaction.save
    redirect_to products_path, notice: "Product is successfully created."
  else
    flash.now[:alert] = "Product or Buy Transaction failed."
    render :new
  end
end

def edit
    @product = @user.products.find(params[:id])
end

  def update
    @product = @user.products.find(params[:id])
    
    if @product.update(product_params)
      redirect_to product_path(@product), notice: "Product was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @product = @user.products.find(params[:id])
    @product.destroy
    redirect_to products_path, notice: "Product was successfully destroyed."
  end

private

    def find_user
      @user = current_user
    end

    def product_params
        params.require(:product).permit(:item_name, :brand, :stock, :price, :description, :product_id)
    end
end
