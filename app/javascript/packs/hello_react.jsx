// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React, { Component } from 'react'

export default class Hello extends Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <div>Hello {this.props.name}!</div>
    )
  }
}
