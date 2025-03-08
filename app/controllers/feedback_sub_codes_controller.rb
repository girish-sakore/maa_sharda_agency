class FeedbackSubCodesController < ApplicationController
  before_action :set_feedback_sub_code, only: %i[ show update destroy ]

  def index
    @feedback_sub_codes = FeedbackSubCode.all

    render json: @feedback_sub_codes
  end

  def show
    render json: @feedback_sub_code
  end

  def create
    @feedback_sub_code = FeedbackSubCode.new(feedback_sub_code_params)

    if @feedback_sub_code.save
      render json: @feedback_sub_code, status: :created, location: @feedback_sub_code
    else
      render json: @feedback_sub_code.errors, status: :unprocessable_entity
    end
  end

  def update
    if @feedback_sub_code.update(feedback_sub_code_params)
      render json: @feedback_sub_code
    else
      render json: @feedback_sub_code.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @feedback_sub_code.destroy!
  end

  private
    def set_feedback_sub_code
      @feedback_sub_code = FeedbackSubCode.find(params[:id])
    end

    def feedback_sub_code_params
      params.fetch(:feedback_sub_code, {})
    end
end
