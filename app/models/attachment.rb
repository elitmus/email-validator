class Attachment < ApplicationRecord
  belongs_to :user
  has_one_attached :csv_file

  def self.read_csv(file)
    rows = CSV.parse(file, headers: true).collect do |row|
      row.to_hash
    end
    return rows
  end

  def self.to_csv(rows, user_id, file_name)
    column_names = rows.first.keys
    additional_column_names = ["Status"]
    column_names += additional_column_names
    s = CSV.generate do |csv|
      csv << column_names
      rows.each do |row|
        values = row.values
        res = Truemail.validate(values[0])
        additional_values_for_row = res.result.success ? ["Valid"] : ["Invalid"]
        values += additional_values_for_row
        csv << values
      end
    end
    return make_csv(s, file_name)
  end

  private

  def self.make_csv(content, file_name)
    output_file_dir = "#{Rails.root}/public/report"
    if !Dir.exists? output_file_dir
      Dir.mkdir(output_file_dir)
    end
    new_file_name = Time.now.to_s + file_name
    output_file_path = "#{output_file_dir}/#{new_file_name}"
    File.open(output_file_path, "w") { |file| file.write(content) }
    return "/report/#{new_file_name}"
  end
end
