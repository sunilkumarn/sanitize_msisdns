require 'spec_helper'
require_relative '../lib/msisdn_sanitizer'

describe MSISDN::Sanitizer do

  subject { MSISDN::Sanitizer }

  let(:msisdn_list) do
    [
        '+918089106942',
        '8089129856',
        '09846752687',
        '00919745044399',
        '67809123456',
        '0939-109456',
        '+91 91 67 100865',
        '914712438548',
        '914712',
        '918891598095',
        '09539368042',
        '0041796704934',
        '+8891090909'
    ]
  end

  let(:filtered_msisdn_list) do
    %w(
          8089106942
          8089129856
          9846752687
          9745044399
          0939109456
          9167100865
          9539368042
      )
  end

  let(:standardized_msisdn_list) do
    {
      international_format:
         %w(
          +918089106942
          +918089129856
          +919846752687
          +919745044399
          +919167100865
          +919539368042
          ),

      local_format:
          %w(
            8089106942
            8089129856
            9846752687
            9745044399
            9167100865
            9539368042
          )
    }
  end

  it 'cleans and filters msisdns by removing all characters which are not digits and +' do
    expect(subject.send(:clean_and_filter, msisdn_list, :in)).to eq filtered_msisdn_list
  end

  it 'standardizes the msisdn as per the format provided' do
    expect(subject.send(:standardize, filtered_msisdn_list, 'local')).to eq standardized_msisdn_list[:local_format]
    expect(subject.send(:standardize, filtered_msisdn_list, 'international')).to eq standardized_msisdn_list[:international_format]
  end

  it 'raises an exception if the msisdn passed in not a string or array' do
    expect{ subject.sanitize( {msisdn: 9897090909} ) }.to raise_error InvalidArgumentTypeException
  end

  it 'raises an exception if the format provided is not local or international' do
    expect{ subject.sanitize('9897090909', format: 'regional' ) }.to raise_error InvalidFormatException
  end

  it 'raises an exception if the country code passed is not in the list of country codes' do
    expect{ subject.sanitize(['9897090909'],  country_code: 'ne' ) }.to raise_error InvalidCountryCodeException
  end

  it 'uses the default options of format and country code if no other options are given' do
    subject.should_receive(:clean_and_filter).with(['9897090909'], :in).and_return([])
    subject.should_receive(:standardize).with([], 'international').and_return([])
    subject.sanitize(['9897090909'])
  end

  it 'uses the format and country code if supplied as arguments' do
    subject.should_receive(:clean_and_filter).with(['9897090909'], :in).and_return([])
    subject.should_receive(:standardize).with([], 'local').and_return([])
    subject.sanitize(['9897090909'], format: 'local', country_code: :in)
  end

  it 'converts any arguments into a string of arrays' do
    subject.stub(:standardize)
    subject.should_receive(:clean_and_filter).exactly(4).times.with(['9897090909'], :in)
    subject.sanitize(['9897090909'], format: 'local')
    subject.sanitize('9897090909', format: 'local')
    subject.sanitize(9897090909, format: 'local')
    subject.sanitize([9897090909], format: 'local')
  end

  it 'returns an array of sanitized msisdns' do
    expect(subject.sanitize( ['9897090909'], format: 'local') ).to be_a_kind_of(Array)
  end

end