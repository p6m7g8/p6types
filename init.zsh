p6df::modules::p6types::version() { echo "0.0.1"; }
p6df::modules::p6types::deps() { ModuleDeps=() }
p6df::modules::p6types::init() {

  local dir="$P6_DFZ_SRC_DIR/p6m7g8/p6types"

  p6_bootstrap "$dir"
}
