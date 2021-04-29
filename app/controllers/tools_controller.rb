# frozen_string_literal: true

class ToolsController < ApplicationController
  def index; end

  def show; end

  def new; end

  def edit; end

  def create
    tool = Tool.new(tool_params)

    if tool.save
      redirect_to tool, notice: 'Tool was successfully created.'
    else
      render :new
    end
  end

  def update
    if tool.update(tool_params)
      redirect_to tools_path, notice: 'Tool was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    tool.destroy

    redirect_to tools_path, notice: 'Tool was successfully destroyed.'
  end

  def translate
    TranslateAndUploadTool.enqueue(tool.id)

    redirect_to tools_path, notice: 'In process...'
  end

  private

  helper_method def tools
    @tools ||= Tool.all
  end

  helper_method def tool
    @tool ||= params[:id].present? ? Tool.find(params[:id]) : Tool.new
  end

  def tool_params
    params.require(:tool).permit(:name, :language)
  end
end
