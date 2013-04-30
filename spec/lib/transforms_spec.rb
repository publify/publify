# coding: utf-8
require 'spec_helper'

describe String do
  describe "#to_title" do
    it 'should build a nice permalink from an accentuated string' do
      "L'été s'ra chaud, l'été s'ra chaud".to_permalink.should == "l-ete-s-ra-chaud-l-ete-s-ra-chaud"
    end
  end
end

