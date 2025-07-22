class AdrsController < ApplicationController
  def create
    @adr = Adr.new(adr_params)
    if @adr.save
      render json: @adr, status: :created
    else
      render json: { errors: @adr.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def accept
    @adr = Adr.find(params[:id])
    if @adr.status == "PROPOSED"
      @adr.accept!
      render json: @adr
    else
      render json: { error: "ADR must be in PROPOSED state" }, status: :unprocessable_entity
    end
  end

  def supersede
    old = Adr.find(params[:id])
    new = Adr.new(adr_params)
    if new.save
      old.supersede_with(new)
      render json: new
    else
      render json: { errors: new.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def adr_params
    params.require(:adr).permit(:title, :context, :decision, :consequences)
  end
end
