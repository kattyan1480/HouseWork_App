class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @categories = current_group.categories.order(:id)
  end

  def new
    @category = current_group.categories.new
  end

  def create
    @category = current_group.categories.new(category_params)

    if @category.save
        redirect_to categories_path, notice: "カテゴリーを追加しました"
    else
        render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @category = current_group.categories.find(params[:id])
    @category.destroy
    redirect_to categories_path, notice: "カテゴリーを削除しました"
  end

    private

  def category_params
    params.require(:category).permit(:name, :stamp, :color)
  end
end