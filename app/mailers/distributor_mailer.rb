class DistributorMailer < ActionMailer::Base
  default from: "sales@buyhairillusion.com"

  def new_distributor(distributor)
    @distributor = distributor
    mail(to: 'ronnie@hairillusion.net', subject: 'Hair Illusion Distributor Request')
  end

  def approved(distributor, password)
    @distributor = distributor
    @password = password
    mail(to: distributor.email, subject: 'Hair Illusion Distributor Request Approved')
  end
end
