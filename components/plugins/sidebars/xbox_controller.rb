class Plugins::Sidebars::XboxController < Sidebars::ComponentPlugin
  display_name "Xbox Gamer Card"
  description "Displays your Xbox Live Gamer Card"

  setting :gamertag, '', 'Xbox Live gamertag'
end
