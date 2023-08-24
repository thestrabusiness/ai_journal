class CoreValuesController < ApplicationController
  def index
    @core_values = CoreValue.all
  end

  def create
    @core_value = CoreValue.new(core_value_params)
    if @core_value.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to core_values_path }
      end
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @core_value = CoreValue.find(params[:id])
    return unless @core_value.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to core_values_path }
    end
  end

  private

  def core_value_params
    params.require(:core_value).permit(:name, :description)
  end
end
