module ActivitiesHelper

  def filter_records(collection)
    record = filter_params[:chart_items].present? ? collection.filter_by_auditable(filter_params[:chart_items]) : collection
    record = filter_params[:actions].present? ? record.filter_by_action(filter_params[:actions]) : record
    record = filter_params[:audited_by].present? ? record.filter_by_user_ids(filter_params[:audited_by]) : record
    record = filter_params[:from_date].present? ? record.filter_by_time(filter_params[:from_date]) : record
  end

  private

  def filter_params
    params.require(:filter).permit(:from_date, :chart_items => [], :actions => [], :audited_by => [])
  end
end