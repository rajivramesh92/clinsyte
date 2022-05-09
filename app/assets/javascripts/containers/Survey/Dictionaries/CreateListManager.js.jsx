
var mapDispatchToProps = (dispatch, ownProps) => {
  return {
    createList: (listData, token) => {
      createList(listData, token, (response, error) => {
        if (response) {
          if (response.data.status === 'success') {
            showToast('List created successfully', 'success');
            ownProps.history.push('/lists');
          }
          else {
            showToast(response.data.errors, 'error');
          }
        }
        else {
          showToast(SOMETHINGWRONG, 'error');
        }
      });
    }
  }
}


var mapStateToProps = (state) => {
  return {
    token: state.auth.token
  }
}

const CreateListManager = connect(mapStateToProps, mapDispatchToProps)(CreateList);
