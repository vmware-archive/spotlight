require 'spec_helper'

describe Category::CiWidget do
  describe '#field' do
    it 'returns hash' do
      expect(subject.fields).to be_a Hash
    end

    it 'has keys' do
      expect(subject.fields.keys).to eq %i{server_type server_url project_name auth_key}
      expect(subject.fields[:server_type]).to eq %i{travis_ci jenkins circle_ci}
    end
  end
end
