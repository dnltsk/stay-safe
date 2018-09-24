import React from 'react';

import NavbarLogo from 'images/sbb-logo.svg';
import './Navbar.scss';

/* eslint-disable react/prefer-stateless-function */
export default class Navbar extends React.PureComponent {
  render() {
    return (
      <nav className="navbar" style={{ padding: 0 }}>
        <img className="navbar__logo" src={NavbarLogo} alt="logo" />
      </nav>
    );
  }
}
