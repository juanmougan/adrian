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

  def update
    @adr = Adr.find(params[:id])

    if params[:adr][:status] == "ACCEPTED"
      return render_error("ADR must be in PROPOSED state") unless @adr.status == "PROPOSED"

      @adr.update!(status: "ACCEPTED")
      render json: @adr and return

    elsif params[:adr][:status] == "SUPERSEDED"
      new_id = params[:adr][:superseeded_by]
      return render_error("Missing 'superseeded_by' ADR id") unless new_id

      @adr.update!(status: "SUPERSEDED", superseeded_by: new_id)
      superseding_adr = Adr.find(new_id)
      superseding_adr.update!(supersedes: @adr.id)

      render json: @adr and return
    end

    render_error("Unsupported status or no update performed")
  rescue => e
    render_error(e.message)
  end

  private

  def adr_params
    params.require(:adr).permit(:title, :context, :decision, :consequences)
  end

  def render_error(message, redirect_path: root_path)
    flash[:alert] = message
    redirect_to redirect_path
  end
end
