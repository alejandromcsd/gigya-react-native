import React, { Component } from 'react';
import { Container, Header, Content, Footer, FooterTab, Button, Icon, Text, H3 } from 'native-base';
import globalStyles from '../styles';

const styles = {
  welcome: { alignSelf: "center", marginTop: 50 },
};

class LoggedIn extends Component {
  render() {
    const { account, onLogout } = this.props;

    return(
      <Container style={globalStyles.container}>
        <Header style={globalStyles.header} />
        <Content>
          <H3 style={styles.welcome}>Welcome {account.profile.firstName}</H3>
        </Content>
        <Footer>
          <FooterTab>
            <Button vertical onPress={onLogout}>
              <Icon name="log-out" />
              <Text>Log out</Text>
            </Button>
          </FooterTab>
        </Footer>
      </Container>
    );
  }
}

export default LoggedIn;
