class FieldParserService
  def csv_to_array(csv_string)
    csv_string.split(',').map(&:strip).reject(&:blank?)
  end
end
