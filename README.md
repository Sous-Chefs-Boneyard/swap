Swap LWRP
=========
This cookbook provides an LWRP for easily creating and managing swap files.

Usage
-----
Add a new swap:
```ruby
swap_file '/mnt/swap' do
  size      1024    # MBs
end
```

Or remove an existing one:
```ruby
swap_file '/mnt/swap' do
  action    :remove
end
```

### LWRP Attributes
<table>
  <tr>
    <th>Attribute</th>
    <th>Description</th>
    <th>Example</th>
    <th>Default</th>
  </tr>
  <tr>
    <td>path</td>
    <td>The path to put the swap file on the system</td>
    <td>/mnt/swap</td>
    <td></td>
  </tr>
  <tr>
    <td>size</td>
    <td>The size (in MBs) for the swap file</td>
    <td>2048</td>
    <td></td>
  </tr>
</table>

Usage
-----
If you're using [berkshelf](https://github.com/RiotGames/berkshelf), add `swap` to your `Berksfile`:

```ruby
cookbook 'swap'
```

Otherwise, install the cookbook from the community site:

    knife cookbook site install swap

Have any other cookbooks depend on this cookbook by adding it to the `metadata.rb`:

```ruby
depends 'swap'
```

Now you can use the LWRP in your cookbook!

Contributing
------------
1. Fork the project
2. Create a feature branch corresponding to you change
3. Commit and test thoroughly
4. Create a Pull Request on github
    - ensure you add a detailed description of your changes

License and Authors
-------------------
- Author:: Seth Vargo (sethvargo@gmail.com)

Copyright 2012, Seth Vargo

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
