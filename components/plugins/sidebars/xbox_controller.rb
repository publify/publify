class Plugins::Sidebars::XboxController < Sidebars::ComponentPlugin
  def self.display_name
    "Xbox Gamer Card"
  end

  def self.description
    "Displays your Xbox Live Gamer Card"
  end

  def self.default_config
    {'gamertag' => ''}
  end

  def configure
  end
end
