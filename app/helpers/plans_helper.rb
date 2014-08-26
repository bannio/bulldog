module PlansHelper
  def get_plan_data
    plans = []
    # plans[0] = {"id" => 0, "name" => "Cancel subscription"}
    Plan.all.each do |p|
      plans[p.id - 1] = {
        "id" => "#{p.id}",
        "name" => "#{p.name} #{number_to_currency(p.amount/100)} per #{p.interval}"
      }
    end
    plans.to_json
  end
end