class AddWizardCompleteThankyouSentToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :wizard_complete_thankyou_sent, :boolean, :default => false
  end
end
