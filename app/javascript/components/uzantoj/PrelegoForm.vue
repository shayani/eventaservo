<template>
  <div>
    <div class="lead">Kiel preleganto</div>
    <div class="form-group row">
      <label class="col-5 col-form-label" for="preleganto">
        Mi estas preleganto
      </label>
      <div class="col-7">
        <div class="form-group form-check">
          <input
            id="preleganto"
            type="checkbox"
            class="form-check-input"
            name="user[preleganto]"
            value="true"
            :checked="this.prelegantoChecked"
            v-model="prelegantoChecked"
          />
        </div>
      </div>
    </div>
    <div v-if="prelegantoChecked">
      <div class="form-group row">
        <label class="col-md-5 col-form-label" for="preleg_temoj">
          Mi prelegas pri la jenaj temoj
        </label>
        <div class="col-md-7">
          <div class="form-group">
            <textarea
              id="preleg_temoj"
              name="preleg_temoj"
              class="form-control"
              rows="3"
              placeholder="Sbriku pri la temoj kiuj vi pretas prelegi."
              v-model="temoj"
            ></textarea>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'PrelegoForm',
  props: {
    prelego: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      prelegantoChecked: false,
      temoj: '',
    }
  },
  mounted() {
    if (this.prelego.preleganto !== undefined) {
      this.prelegantoChecked = this.prelego.preleganto === 'true'
    }

    if (this.prelego.temoj !== undefined) {
      this.temoj = this.prelego.temoj
    }
  },
}
</script>

<style scoped></style>
