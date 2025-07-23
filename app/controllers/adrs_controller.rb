class AdrsController < ApplicationController
  def index
    @adrs = Adr.order(created_at: :desc)
    @adr = Adr.new
  end

  def create
    @adr = Adr.new(adr_params)

    if @adr.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to adrs_path, notice: "ADR created" }
      end
    else
      render :index
    end
  end

  private

  def adr_params
    params.require(:adr).permit(:title, :context, :decision, :consequences)
  end
end
