# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

project_id   = attribute('project_id')
network_name = attribute('network_name')

control "gcloud" do
  title "gcloud configuration"

  describe command("gcloud compute networks subnets describe subnet-01 --project=#{project_id} --region=us-west1 --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    it "should have the right CIDR" do
      expect(data).to include(
        "ipCidrRange" => "10.10.10.0/24"
      )
    end

    it "should not have Private Google Access" do
      expect(data).to include(
        "privateIpGoogleAccess" => false
      )
    end

    it "logConfig should not be enabled" do
      expect(data).to include(
        "logConfig" => {
          "enable" => false,
        }
      )
    end
  end

  describe command("gcloud compute networks subnets describe subnet-02 --project=#{project_id} --region=us-west1 --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    it "should have the right CIDR" do
      expect(data).to include(
        "ipCidrRange" => "10.10.20.0/24"
      )
    end

    it "should have Private Google Access" do
      expect(data).to include(
        "privateIpGoogleAccess" => true
      )
    end

    it "Default log config should be correct" do
      expect(data).to include(
        "logConfig" => {
          "aggregationInterval" => "INTERVAL_5_SEC",
          "enable" => true,
          "flowSampling" => 0.5,
          "metadata" => "INCLUDE_ALL_METADATA",
          "filterExpr" => "true"
        }
      )
    end
  end

  describe  command("gcloud compute networks subnets describe subnet-03 --project=#{project_id} --region=us-west1 --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    it "should have the right CIDR" do
      expect(data).to include(
        "ipCidrRange" => "10.10.30.0/24"
      )
    end

    it "should not have Private Google Access" do
      expect(data).to include(
        "privateIpGoogleAccess" => false
      )
    end

    it "Log config should be correct" do
      expect(data).to include(
        "logConfig" => {
          "aggregationInterval" => "INTERVAL_10_MIN",
          "enable" => true,
          "flowSampling" => 0.7,
          "metadata" => "INCLUDE_ALL_METADATA",
          "filterExpr" => "true"
        }
      )
    end
  end
end
