local function is_helm_chart_template(path)
  if not path:match "/templates/" then
    return false
  end

  return vim.fs.find("Chart.yaml", { path = vim.fs.dirname(path), upward = true })[1] ~= nil
end

vim.filetype.add {
  extension = {
    tf = "terraform",
    tfvars = "terraform-vars",
    tfbackend = "terraform-vars",
  },
  pattern = {
    [".*/templates/.*%.ya?ml"] = function(path)
      if is_helm_chart_template(path) then
        return "helm"
      end
    end,
    [".*/templates/.*%.tpl"] = function(path)
      if is_helm_chart_template(path) then
        return "helm"
      end
    end,
  },
}
