class PulseChecksController < ApplicationController
  def show
    @pulse_check = PulseCheck.last
  end

  def create
    GeneratePulseCheck.run! unless weekly_pulse_check_exists?
    redirect_to pulse_check_path
  end

  private

  def weekly_pulse_check_exists?
    PulseCheck.where("created_at > ?", 1.week.ago).exists?
  end
end
