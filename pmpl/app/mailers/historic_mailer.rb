class HistoricMailer < ActionMailer::Base
  default :from => "pmpl_historico@gmail.com"
  
  def vehicle_historic_alert(historic)
    
    @historic = historic
    
    mail(:to => "pmpl.historico@gmail.com", :subject => "Troca de oleo se aproximando")
  end
  
  def machine_historic_alert(historic)
    
    @historic = historic
    
    mail(:to => "pmpl.historico@gmail.com", :subject => "Troca de oleo se aproximando")
  end
end