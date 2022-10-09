class DependencyValidator < ActiveModel::Validator
  def validate(record)
    if record.package.external? &&
       record.component?
      record.errors.add :dependency, :external
    end
  end
end
