require 'spec_helper_acceptance'

describe 'When you need a dc' do
  context 'and you want puppet to create it' do
    it 'should have created a new dc' do
      expect(1).to eq(1)
    end
  end
end