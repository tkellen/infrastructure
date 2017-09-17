/*!
 * Inspired by:
 *
 * Hamburgers
 * @description Tasty CSS-animated hamburgers
 * @author Jonathan Suh @jonsuh
 * @site https://jonsuh.com/hamburgers
 * @link https://github.com/jonsuh/hamburgers
 */

import { Component } from 'react'

export default class extends Component {
  constructor (props) {
    super(props)
    this.handleClick = this.handleClick.bind(this)
    this.clickHandler = this.props.clickHandler
    this.state = {
      active: false
    }
  }

  handleClick () {
    const next = !this.state.active
    this.setState({active: next})
    this.clickHandler(next)
  }

  render () {
    const activeClass = this.state.active ? 'is-active' : ''
    return (
      <button
        ref='button'
        type='button'
        aria-label='Menu'
        aria-controls='navigation'
        className={activeClass}
        onClick={this.handleClick}
        >
        <style jsx>{`
          /* Don't show when we are on large screens */
          @media(min-width: 768px) {
            button {
              display: none !important;
            }
          }
          button {
            padding: 15px 15px;
            display: inline-block;
            cursor: pointer;
            transition-property: opacity, filter;
            transition-duration: 0.15s;
            transition-timing-function: linear;
            font: inherit;
            color: inherit;
            text-transform: none;
            background-color: transparent;
            border: 0;
            margin: 0;
            overflow: visible;
          }
          button:hover {
            opacity: 0.7;
          }
          div {
            width: 40px;
            height: 24px;
            display: inline-block;
            position: relative;
          }
          span {
            display: block;
            top: 50%;
            margin-top: -2px;
            transition-duration: 0.075s;
            transition-timing-function: cubic-bezier(0.55, 0.055, 0.675, 0.19);
          }
          span, span::before, span::after {
            width: 40px;
            height: 4px;
            background-color: #fff;
            border-radius: 4px;
            position: absolute;
            transition-property: transform;
            transition-duration: 0.15s;
            transition-timing-function: ease;
          }
          span::before, span::after {
            content: "";
            display: block;
          }
          span::before {
            top: -10px;
            transition: top 0.075s 0.12s ease,
                        opacity 0.075s ease;
          }
          span::after {
            bottom: -10px;
            transition: bottom 0.075s 0.12s ease,
                        transform 0.075s cubic-bezier(0.55, 0.055, 0.675, 0.19);
          }
          .is-active span {
            transform: rotate(45deg);
            transition-delay: 0.12s;
            transition-timing-function: cubic-bezier(0.215, 0.61, 0.355, 1);
          }
          .is-active span::before {
            top: 0;
            opacity: 0;
            transition: top 0.075s ease,
                        opacity 0.075s 0.12s ease;
          }
          .is-active span::after {
            bottom: 0;
            transform: rotate(-90deg);
            transition: bottom 0.075s ease,
                        transform 0.075s 0.12s cubic-bezier(0.215, 0.61, 0.355, 1);
          }
        `}</style>
        <div><span /></div>
      </button>
    )
  }
}
