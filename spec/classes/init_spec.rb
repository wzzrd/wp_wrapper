require 'spec_helper'
describe 'wp_wrapper' do

  context 'with defaults for all parameters' do
    it { should contain_class('wp_wrapper') }
  end
end
