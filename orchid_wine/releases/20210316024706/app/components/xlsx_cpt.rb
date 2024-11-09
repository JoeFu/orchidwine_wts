def write_xlsx(datas,filename, types)
  workbook = WriteXLSX.new("#{Const::UPLOAD_EXCEL}/#{filename}.xlsx")
  worksheet = workbook.add_worksheet
  row = 0
  datas.map do |data|
    col = 0
    if data.first.class == Hash && data.first.present?
      _format = workbook.add_format(data[0])
      data[1..data.size].map do |d|
        worksheet.write(row, col, d, _format)
        col += 1
      end
    else
      data[0..data.size].map do |d|
        worksheet.write(row, col, d)
        col += 1
      end
    end

    row += 1
  end

  workbook.close
end
