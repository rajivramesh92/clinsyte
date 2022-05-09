var mapStateToProps = (state) => {
  return {
    token: state.auth.token
  }
}

var mapDispatchToProps = (dispatch) => {
  return {
    getTherapyProfileData: (therapyId, token, callback) => {
      getTherapyProfileData(therapyId, token, (response, error) => {
        if (response) {
          if (response.data.status === 'success') {

            var data = response.data.data;
            var tagsWithCompounds = data.tag_with_compounds;

            if(!_.isEmpty(data.untagged_compounds)) {
             var untaggedCompounds = {
                compounds: data.untagged_compounds,
                tag: {
                  id: 0,
                  name: 'Compounds without tags'
                }
              }
              tagsWithCompounds = tagsWithCompounds.concat(untaggedCompounds);
            }

            callback({
              ..._.omit(data, 'tag_with_compounds', 'untagged_compounds'),
              tagsWithCompounds
            });
          }
          else {
            showToast(response.data.errors, 'error');
          }
        }
        else {
          showToast(SOMETHINGWRONG, 'error');
        }
      })
    }
  }
}

const TherapyProfileManager = connect(mapStateToProps, mapDispatchToProps)(TherapyProfile);
