class AddsTextFilterGithubFlavoredMarkdown < ActiveRecord::Migration

  def up
    say "Adds TextFilter GitHub Flavored Markdown"
    TextFilter.create(name: 'github flavored markdown',
                      description: 'GitHub Flavored Markdown',
                      markup: "githubflavoredmarkdown",
                      filters: [],  params: { })
  end

  def down
    say "Remove TextFilter GitHub Flavored Markdown"
    filter = TextFilter.find_by_name('github flavored markdown')
    filter.destroy

  end
end
