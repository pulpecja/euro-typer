require 'spec_helper'

RSpec.describe GroupService do
  before(:each) do
    @user = create :user
    # @group = create :group
    # sign_in(@user, scope: :user)
  end

  subject { GroupService.new(params, group) }

      let(:group) { create :group }
      let(:competition) { create :competition }
      let(:params) { { group: {
                         competition_ids: [competition.id] } } }

  xdescribe "passing valid parameters" do
    it "is successful" do
      expect(subject.call).to be_success
    end

    # it "creates invoice" do
    #   invoice = subject.call.invoice
    #   expect(invoice).to be_persisted
    #   expect(invoice.company_name).to eq("ACME Corp.")
    # end

    # it "notifies via notification center" do
    #   expect(notification_center).to receive(:invoice_created)
    #   subject.call
    # end
end


#   it 'initialize without exception' do
#     assert_nothing_raised do
#       base = GroupService.new
#     end
#   end

#   it '#add_competitions adds competitions' do
#     assert_nothing_raised do

#       base = GroupService.new(params, group)
#       base.add_competitions
# binding.pry
#       # assert base.respond_to?(:initialize_driver)
#       # assert base.respond_to?(:get_page)
#       # assert base.respond_to?(:close_browser)
#     end
#   end
end