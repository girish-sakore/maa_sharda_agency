class FeedbackCodesController < ApplicationController
  before_action :set_feedback_code, only: [:show, :update, :destroy]

  def index
    @feedback_codes = FeedbackCode.all
    render json: serialized_codes
  end

  def show
    render json: @feedback_code
  end

  def create
    @feedback_code = FeedbackCode.new(feedback_code_params)

    if @feedback_code.save
      render json: @feedback_code, status: :created
    else
      render json: @feedback_code.errors, status: :unprocessable_entity
    end
  end

  def update
    if @feedback_code.update(feedback_code_params)
      render json: @feedback_code
    else
      render json: @feedback_code.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @feedback_code.destroy
    head :no_content
  end

  private

  def set_feedback_code
    @feedback_code = FeedbackCode.find(params[:id])
  end

  def feedback_code_params
    params.require(:feedback_code).permit(:code, :use_sub_code, :category, :field_description, fields: [],
    sub_codes_attributes: [:id, :sub_code, :field_description, {fields: []}, :_destroy]) 
  end

  def serialized_codes
    @feedback_codes.map do |fcode|
      {
        code: fcode.code,
        use_sub_code: fcode.use_sub_code,
        category: fcode.category,
        description: fcode.description,
        fields: fcode.fields
      }
    end
  end
end
