
var mapDispatchToProps = (dispatch) => {
  return {
    getLists: (token, callback) => {
      getLists(token, (response, error) => {
        if (response) {
          if (response.data.status === 'success') {
            callback(response.data.data);
          }
          else {
            showToast(response.data.errors, 'error');
          }
        }
        else {
          showToast(SOMETHINGWRONG, 'error');
        }
      })
    },
    deleteList: (listId, token, callback) => {
      deleteList(listId, token, (response, error) => {
        if (response) {
          if (response.data.status === 'success') {
            showToast('List deleted successfully', 'success');
            callback(response.data.data);
          }
          else {
            showToast(response.data.errors, 'error');
          }
        }
        else {
          showToast(SOMETHINGWRONG, 'error');
        }
      })
    },
    updateList: (listId, data, token, callback) => {
      updateList(listId, data, token, (response, error) => {
        if (response) {
          if (response.data.status === 'success') {
            showToast('List updated successfully', 'success');
            callback(response.data.data);
          }
          else {
            showToast(response.data.errors, 'error');
          }
        }
      })
    }
  }
}

var mapStateToProps = (state) => {
  return {
    token: state.auth.token
  }
}

const ListsViewManager = connect(mapStateToProps, mapDispatchToProps)(ListsView);
