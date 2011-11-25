require File.dirname(__FILE__) + '/../spec_helper'

class Hiera
  module Backend
    describe Puppet_encflat_backend do
      before do
        Hiera.stubs(:warn)
        Hiera.stubs(:debug)
        Backend.stubs(:datasources).yields([])

        @mockresource = mock
        @mockresource.stubs(:name).returns("ntp::config")

        @mockscope = mock
        @mockscope.stubs(:resource).returns(@mockresource)

        @scope = Scope.new(@mockscope)

        @backend = Puppet_encflat_backend.new
      end

      describe "#lookup" do
        it "should return the first found data" do
          Backend.expects(:empty_answer).returns(nil)
          Backend.expects(:parse_answer).with("rspec", @scope).returns("rspec")
          catalog = mock
          catalog.expects(:classes).returns(["rspec", "override"])
          @mockscope.expects(:catalog).returns(catalog)
          @mockscope.expects(:function_include).never
          @mockscope.expects(:lookupvar).with("override::key").returns("rspec")
          @mockscope.expects(:lookupvar).with("rspec::key").never

          @backend.expects(:hierarchy).with(@scope, "override").returns(["override", "rspec"])
          @backend.lookup("key", @scope, "override", nil).should == "rspec"
        end

        it "should return an array of found data for array searches" do
          Backend.expects(:empty_answer).returns([])
          Backend.expects(:parse_answer).with("rspec::key", @scope).returns("rspec::key")
          Backend.expects(:parse_answer).with("test::key", @scope).returns("test::key")
          catalog = mock
          catalog.expects(:classes).returns(["rspec", "test"])
          @mockscope.expects(:catalog).returns(catalog)
          @mockscope.expects(:function_include).never
          @mockscope.expects(:lookupvar).with("rspec::key").returns("rspec::key")
          @mockscope.expects(:lookupvar).with("test::key").returns("test::key")

          @backend.expects(:hierarchy).with(@scope, nil).returns(["rspec", "test"])
          @backend.lookup("key", @scope, nil, :array).should == ["rspec::key", "test::key"]
        end
      end
    end
  end
end

