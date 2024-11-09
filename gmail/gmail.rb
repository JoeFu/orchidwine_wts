require 'gmail'

gmail = Gmail.connect(:xoauth2, 'wuyueit@gmail.com', "ya29.Glu0BTvDTpxoYHHccg-2kmgWG7Swvcl3xkjq1bFWyyGVAcTjhEqO6f_8dEdTSc-fTSb4IPw9SNo3s3W3TO1LIGarj7msKyJ6RjJLFJkL2K-SDROP8TZmRN4z2GRH")

email = gmail.compose do
  to "wuyue@techjumper.com"
  subject "Having fun in Puerto Rico!"
  body "Spent the day on the road..."
end
email.deliver!