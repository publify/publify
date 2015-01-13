# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Daley', city: cities.first)

Blog.create

%w(
  debt
  borrowing
  loans
  payday-loans
  credit-score
  credit-rating
  free-debt-advice
  bankruptcy
  remortgage
  debt-management
  credit cards
  work
  pensions
  retirement
  tax
  self-employed
  redundancy
  benefits
  tax-credits
  pension-scams
  state-pension
  annuity
  insurance
  home-insurance
  buildings-insurance
  flood-insurance
  mobile-phones
  life-insurance
  ppi
  critical-illness-insurance
  car-insurance
  travel-insurance
  pet-insurance
  cars
  travel
  car-finance
  travel-money
  holidays
  budgeting
  managing-money
  bank-accounts
  current-accounts
  debit-cards
  overdrafts
  credit-unions
  premium-bonds
  id-theft
  scams
  your-rights
  bills
  prepaid-cards
  student-finance
  student-loans
  christmas
  council-tax
  shopping
  gas
  electricity
  water-bill
  universal-credit
  child-benefit
  homes
  mortgages
  home-buying
  first-time-buyer
  stamp-duty
  help-to-buy
  buy-to-let
  renting
  savings
  investing
  nisa
  child-trust-funds
  junior-isas
  births
  deaths
  funeral
  family
  divorce
  separation
  maternity-pay
  paternity-pay
  childcare
  wills
  care
  disability
  long-term-care
  wedding
  how-to
  having-a-baby
  news
).map {|tag| Tag.create(name: tag, display_name: tag.gsub(/-/, " ").titleize) }

PageSidebar.create(active_position: 0, staged_position: 0)
TagSidebar.create(active_position: 1)
ArchivesSidebar.create(active_position: 2)
StaticSidebar.create(active_position: 3)
MetaSidebar.create(active_position: 4)

TextFilter.create(name: 'none', description: 'None',
                  markup: 'none', filters: [], params: {})
TextFilter.create(name: 'markdown', description: 'Markdown',
                  markup: "markdown", filters: [], params: {})
TextFilter.create(name: 'smartypants', description: 'SmartyPants',
                  markup: 'none', filters: [:smartypants], params: {})
TextFilter.create(name: 'markdown smartypants', description: 'Markdown with SmartyPants',
                  markup: 'markdown', filters: [:smartypants], params: {})
TextFilter.create(name: 'textile', description: 'Textile',
                  markup: 'textile', filters: [], params: {})
TextFilter.create(name: 'links bold italic', description: 'Only Links (with nofollow added), bold and italic tags permitted',
                  markup: 'none', filters: [:linksbolditalic], params: {})

admin = Profile.create(label: 'admin', nicename: 'Publify administrator',
                       modules: [:dashboard, :articles, :notes, :pages, :feedback, :media, :sidebar, :profile, :users, :settings, :seo])
publisher = Profile.create(label: 'publisher', nicename: 'Blog publisher',
                           modules: [:dashboard, :articles, :notes, :pages, :feedback, :media, :profile])
contributor = Profile.create(label: 'contributor', nicename: 'Contributor',
                             modules: [:dashboard, :articles, :notes, :pages, :feedback, :media, :profile])

Dir.mkdir("#{::Rails.root.to_s}/public/files") unless File.directory?("#{::Rails.root.to_s}/public/files")
