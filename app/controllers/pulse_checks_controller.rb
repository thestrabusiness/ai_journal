class PulseChecksController < AuthenticatedController
  def show
    @pulse_check = current_user.pulse_checks.last
  end

  def create
    GeneratePulseCheck.run!(current_user) unless weekly_pulse_check_exists?
    redirect_to pulse_check_path
  end

  private

  def weekly_pulse_check_exists?
    current_user.pulse_checks.where("created_at > ?", 1.week.ago).exists?
  end
end
