JDoc
====
Pretty documentation generator for large projects

Description
-----------

JDoc is a Jekyll plugin that lets you organize your documentation into a hierarchical file structure.  It was created primarily to generate [Project Pages](http://pages.github.com/) for large projects where the documentation needs to be organized hierarchically across multiple files.

Getting Started
---------------

1. Install [jekyll](https://github.com/mojombo/jekyll)
1. Clone the [jdoc-example](https://github.com/tombenner/jdoc-example) repo
1. Start jekyll in that directory using `jekyll --server` ([read more](https://github.com/mojombo/jekyll/wiki/usage)) and see the site [here](http://localhost:4000/jdoc-example/)
1. Edit the files in `documentation/` to start documenting!

Tips:

* You might want to use `jekyll --server --auto` to automatically regenerate the site when you modify files.
* You can change the root URL of the site with the `baseurl` value in _config.yml.
* A larger example can be found [here](https://github.com/tombenner/wp-mvc-doc).

File Structure
--------------

Documentation is organized in the `documentation` directory in root Jekyll directory.  The file structure looks like this:

    documentation/
        first_topic/
            _sort.yml
            first_subtopic.md
            second_subtopic.md
            index.md
        second_topic.md

This structure will be rendered into a hierarchical menu.  `index.md` is the content that's shown for `first_topic`.

`_sort.yml` is optional.  If it's included in a directory, it specifies the order in which that directory's topics are rendered in the menu.  In the example above, it might look like this:

    first_subtopic
    second_subtopic

Documentation Syntax
--------------------

Each file behaves just like a Jekyll file does, except that the YAML header isn't required. An initial `---` is required, though:

    ---
    Here's some documentation on this topic.

The title is inferred from the file's name, but you can explicitly set the title using the YAML header

    ---
    title: My Custom Title
    ---
    Here's some documentation on this topic.

Tags
----

### doc_link

Creates a link to another topic.  The first argument is the path to the topic; the second is the text:

    {% doc_link first_topic My custom text %}

    <a href="/first_topic/">My custom text</a>

If the second argument is omitted, the title of the topic will be used:

    {% doc_link first_topic/second_subtopic %}

    <a href="/first_topic/second_subtopic/">Second Subtopic</a>


### doc_children

Renders all of the current topic's children in a single page.  [Here](http://tombenner.github.com/jdoc-example/documentation/first_topic/first_subtopic/)'s an example of the output.

    {% doc_children %}

### doc_menu

Renders the hierarchical menu of topics.

    {% doc_menu %}
