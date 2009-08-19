require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe HourlyRate do
  
  before { HourlyRate.all.destroy! }

  describe ":value accessor" do
    it "should work with numbers" do
      HourlyRate.gen :value => 567.89
      HourlyRate.first.value.should == 567.89
    end
    
    it "should work with nil" do
      hourly_rate = HourlyRate.make :value => nil
      hourly_rate.value.should == nil
    end
  end
  
  it "should not allow to save record without :project assigned" do
    hourly_rate = HourlyRate.make(:project => nil)
    hourly_rate.save.should be_false
    hourly_rate.errors.on(:project_id).should_not be_empty
  end
  
  it "should not allow to save record without :role assigned" do
    hourly_rate = HourlyRate.make(:role => nil)
    hourly_rate.save.should be_false
    hourly_rate.errors.on(:role_id).should_not be_empty
  end
  
  it "should not allow to save record without :takes_effect_at" do
    hourly_rate = HourlyRate.make(:takes_effect_at => nil)
    hourly_rate.save.should be_false
    hourly_rate.errors.on(:takes_effect_at).should_not be_empty
  end
  
  it "should not allow to save record without :value" do
    hourly_rate = HourlyRate.make(:value => nil)
    hourly_rate.save.should be_false
    hourly_rate.errors.on(:value).should_not be_empty
  end
  
  it "should not allow to save record without :currency" do
    hourly_rate = HourlyRate.make(:currency => nil)
    hourly_rate.save.should be_false
    hourly_rate.errors.on(:currency).should_not be_empty
  end
  
  it "should not allow to save record with invalid :currency" do
    hourly_rate = HourlyRate.make(:currency => 'invalid currency')
    hourly_rate.save.should be_false
    hourly_rate.errors.on(:currency).should_not be_empty
  end
  
  it "should not allow to save record with the same set of :project, :role and :takes_effect_at" do
    attributes = { :project => fx(:oranges_first_project), :role => fx(:developer), :takes_effect_at => Date.today }
    
    hourly_rate = HourlyRate.make(attributes)
    duplicated_hourly_rate = HourlyRate.make(attributes)
    
    hourly_rate.save.should be_true
    duplicated_hourly_rate.save.should be_false
    duplicated_hourly_rate.errors.on(:takes_effect_at).should_not be_empty
  end
  
  it "should have default order by :takes_effect_at" do
    hr1 = HourlyRate.gen(:takes_effect_at => Date.today - 2)
    hr2 = HourlyRate.gen(:takes_effect_at => Date.today    )
    hr3 = HourlyRate.gen(:takes_effect_at => Date.today - 4)

    HourlyRate.all.should == [hr3, hr1, hr2]
  end

end