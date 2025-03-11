class FeedbacksController < ApplicationController
  before_action :set_feedback, only: %i[ show update destroy ]

  def index
    allocation_draft = AllocationDraft.find(params[:allocation_id])
    @feedbacks = allocation_draft.feedbacks.includes(:feedback_code, :allocation_draft)

    render json: {
      feedbacks: @feedbacks.as_json(include: { feedback_code: {only: :code}}),
      allocation_draft: allocation_draft,
    }
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Allocation Draft not found" }, status: :not_found
  end

  def show
    render json: @feedback
  end

  def create
    allocation_draft = AllocationDraft.find_by(id: params[:allocation_id])
    unless allocation_draft.nil?
      # Some validations
      # if adding feedback is needed at all
      # Need to check if case is resolved
      # or case banned
      # or case expired
      # or any other reason
      # render json: { message: 'Not allowed' }, status: :bad_request
      
      code = params[:feedback][:code]
      feedback_code = FeedbackCode.find_by(code: code)
      @feedback = allocation_draft.feedbacks.new(feedback_params.merge({:feedback_code_id => feedback_code.id}))
      
      if @feedback.save
        update_allocation_draft(allocation_draft)
        render json: {message: 'Feedback added successfully', feedback: @feedback}, status: :created
      else
        render json: { message: 'Not saved, Please check again!!', errors: @feedback.errors }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Allocation not found'}, status: :unprocessable_entity 
    end
  rescue => e
    # render json: { message: 'something went wrong', errors: e}, status: :bad_request
    render_error(e)
  end

  def update
    if @feedback.update(feedback_params)
      render json: @feedback
    else
      render json: @feedback.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @feedback.destroy!
  end

  private
    def set_feedback
      @feedback = Feedback.find(params[:id])
    end

    def feedback_params
      params.require(:feedback).permit(:amount, :remarks, :next_payment_date, :ptp_date, :settlement_amount, :settlement_date, :new_address)
    end

    def update_allocation_draft(allocation_draft)
      feedback = ""
      code = @feedback.feedback_code.code
      feedback += " #{@feedback.remarks}" unless @feedback.remarks.nil?
      feedback += ", Amount #{@feedback.amount}" unless @feedback.amount.nil?
      feedback += ", Next payment date #{@feedback.next_payment_date}" unless @feedback.next_payment_date.nil?
      feedback += ", PTP Date #{@feedback.ptp_date}" unless @feedback.ptp_date.nil?
      feedback += ", Settlement amount #{@feedback.settlement_amount}" unless @feedback.settlement_amount.nil?
      feedback += ", Settlement date #{@feedback.settlement_date}" unless @feedback.settlement_date.nil?
      feedback += ", New address #{@feedback.new_address}" unless @feedback.new_address.nil?
      feedback += ", looged at: #{Time.now.to_s}"

      allocation_draft.update!(
        res: params[:feedback][:resolution],
        f_code: code,
        ptp_date: @feedback.ptp_date,
        feedback: feedback,
      )
    end
end
