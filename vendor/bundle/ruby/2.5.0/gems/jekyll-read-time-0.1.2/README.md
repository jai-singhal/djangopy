# Jekyll Read Time

Jekyll liquid tag to indicating the read time of the content

## Usage

Add the following to your `Gemfile`'
```rb
group :jekyll_plugins do
  gem "jekyll-read-time", "~> 0.1.0"
end
```

Add the following to your `_config.yml`

```yml
plugins:
  - jekyll-read-time
```

Place one of the following tags in your layout

`{{ content | read_time_short }}`

This generates the reading time as a number, like "4 minute read" or "less than 1 minute read"

`{{ content | read_time }}`

This generates the reading time as like "4 min read"
