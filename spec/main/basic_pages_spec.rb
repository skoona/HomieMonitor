
# Ref: http://testing-for-beginners.rubymonstas.org/rack_test/rack.html
# Ref: http://tutorials.jumpstartlab.com/topics/capybara/capybara_with_rack_test.html


# describe Skn::HomieMonitor, "Application pages Respond Correctly. ", roda: :app do
describe "Application pages Respond Correctly. " do

  context "Basic Navigation" do

    it "returns http success" do
      get "/"
      expect(last_response.status).to eq 200

      get "/profiles/devices"
      expect(last_response.status).to eq 200

      get "/profiles/details/HomeOffice"
      expect(last_response.status).to eq 200

      get "/profiles/manage"
      expect(last_response.status).to eq 200
    end

  end

  context "Honors FirmWare Uploads. " do

    it "/homie/upload returns expected response" do
      post "/homie/uploads"
      expect(last_response.status).to eq 500
    end

  end

end
