class FinancialEntitiesController < ApplicationController
  before_action :authorize_request
  before_action :not_admin?
  before_action :set_financial_entity, only: %i[ show update destroy ]

  # GET /financial_entities
  def index
    @financial_entities = FinancialEntity.all

    render json: @financial_entities
  end

  # GET /financial_entities/1
  def show
    render json: @financial_entity
  end

  # POST /financial_entities
  def create
    @financial_entity = FinancialEntity.new(financial_entity_params)

    if @financial_entity.save
      render json: @financial_entity, status: :created
    else
      render json: @financial_entity.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /financial_entities/1
  def update
    if @financial_entity.update(financial_entity_params)
      render json: @financial_entity
    else
      render json: @financial_entity.errors, status: :unprocessable_entity
    end
  end

  # DELETE /financial_entities/1
  def destroy
    @financial_entity.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_financial_entity
      @financial_entity = FinancialEntity.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def financial_entity_params
      params.permit(:name, :code, :contact_number, :email)
    end
end
