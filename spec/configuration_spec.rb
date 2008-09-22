require File.expand_path(File.join(File.dirname(__FILE__),"spec_helper.rb"))
require 'stickler'

describe Stickler::Configuration do
  before( :each ) do
    @config_file_name = "/tmp/stickler.#{Process.pid}.yml"
    FileUtils.cp Stickler::Paths.data_path( "stickler.yml"), @config_file_name 
    @config = Stickler::Configuration.new( @config_file_name )
  end

  after( :each ) do
    FileUtils.rm_f @config_file_name
  end

  %w[ downstream_source sources bulk_threshold benchmark verbose update_sources backtrace ].each do |key|
    it "has a value for #{key}" do
      @config.send( key ).should_not == nil
    end
  end

  it "has an array of sources" do
    @config.sources.should be_instance_of( Array )
  end

  it "can assign an arbitrary key/value pair like a hash" do
    @config[:foo]  = 'bar'
    @config['foo'].should == 'bar'
  end

  it "lists its keys" do
    @config.keys.size.should > 0
  end

  it "is NOT really verbose by default" do
    @config.really_verbose.should == false
  end

  it "it can be really verbose" do
    @config['verbose'] = "really verbose"
    @config.really_verbose.should == true
  end

  it "can write the configuration back out to a file" do
    @config.sources << "http://gems.github.com"
    @config.write
    @config = Stickler::Configuration.new( @config_file_name )
    @config.sources.size.should == 2
    @config.sources.should be_include( "http://gems.github.com" )
  end

end