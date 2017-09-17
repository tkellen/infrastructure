import request from 'axios'
import { Component } from 'react'

import theme from '../theme'

export default class extends Component {
  constructor (props) {
    super(props)
    this.handleSubmit = this.handleSubmit.bind(this)
    this.handleInputChange = this.handleInputChange.bind(this)
    this.router = this.props.router
    this.state = {
      formData: {
        listId: props.listId,
        groupId: props.groupId
      }
    }
  }

  handleInputChange (event) {
    const { name, value } = event.target
    const { formData } = this.state
    formData[name] = value
    this.setState({errors:null})
    this.setState(formData)
  }

  async handleSubmit (event) {
    event.preventDefault()
    const { formData } = this.state
    const { endpoint, router, baseUrl, errorUrl } = this.props
    try {
      const response = await request.post(endpoint, formData)
      const { message } = response.data
      router.push({
        pathname: `${baseUrl}/${message}`
      })
    } catch (err) {
      // get the details of the response if we threw due to a bad xhr request
      const { response } = err;
      // if we have no response, or the status code isn't 400, just bail
      if (!response || !response.data || response.status !== 400) {
        return router.push({
          pathname: errorUrl
        })
      }
      // get the messages that indicate what was wrong with the request
      const { messages } = response.data
      // show the errors
      this.setState({errors:response.data.message})
    }
  }

  render () {
    const { errors } = this.state
    return (
      <form onSubmit={this.handleSubmit}>
        <div className="errors">
          {errors && JSON.stringify(errors)}
        </div>
        <style jsx>{`
          input {
            font-family: "${theme.fonts.sansSerif}";
            font-size: 4vw;
            border: 0;
            background-color: #fff;
          }
        `}</style>
        <input
          type='text'
          name='firstName'
          placeholder='First Name'
          onChange={this.handleInputChange}
          required
        />
        <br />
        <input
          type='email'
          name='emailAddress'
          placeholder='Email'
          onChange={this.handleInputChange}
          required
        />
        <br />
        We'll keep your email secret and safe.
        <br />
        <input type='submit' value='action word to take a next step' />
      </form>
    )
  }
}
