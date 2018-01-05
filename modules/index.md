---
layout: default
---

# Modules

Workshop modules are listed in order of the schedule. The R script
(<span><i class="fas fa-code"></i></span>) and data (<span><i
class="fas fa-database"></i></span>) used to create each module will be
linked at the top of the page. Alternately, all scripts and data may
be downloaded or cloned in bulk from the workshop's [GitHub
repository]({{ site.repo }}).

## Directory structure

All modules assume the following directory structure:
```
rworkshop/
|
|__ data/
|   |
|   |-- module1.data
|   |-- module2.data
|   |...
|
|__ scripts/
|   |
|   |-- module1.R
|   |-- module2.R
|   |...
```

## Links to modules

<ul class="posts">
{% for post in site.categories.module reversed %}
	<li>
		<a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>
	</li>
{% endfor %}
</ul>
