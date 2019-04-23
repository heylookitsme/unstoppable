class ZipCodeValidator < ActiveModel::EachValidator
  ZIP_CODE_REGEX = /^\d{5}(-\d{4})?$/

  def validate_each(record, attribute, value)
    unless ZIP_CODE_REGEX.match value
      record.errors.add(attribute, "#{value} is not a valid zip code")
    end
  end
end

