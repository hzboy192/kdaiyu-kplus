<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="模板Key" prop="title">
        <el-input v-model="queryParams.tplKey" placeholder="请输入模板Key" clearable style="width: 240px"
          @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="模板标题" prop="title">
        <el-input v-model="queryParams.title" placeholder="请输入模板标题" clearable style="width: 240px"
          @keyup.enter="handleQuery" />
      </el-form-item>
      <!-- 
      <el-form-item label="模板语言" prop="tplLang">
        <el-input v-model="queryParams.tplLang" placeholder="请输入模板语言" clearable style="width: 240px"
          @keyup.enter="handleQuery" />
      </el-form-item> 
      -->
      <el-form-item label="启用状态" prop="enabled">
        <el-select v-model="queryParams.enabled" placeholder="启用状态" clearable style="width: 120px">
          <el-option v-for="dict in sys_enabled_char" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item label="更新时间" style="width: 308px">
        <el-date-picker v-model="dateRange" value-format="YYYY-MM-DD" type="daterange" range-separator="-"
          start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="Plus" @click="handleAdd"
          v-hasRole="['ROLE_ADMIN', 'ROLE_SUPER_ADMIN']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate"
          v-hasRole="['ROLE_ADMIN', 'ROLE_SUPER_ADMIN']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete"
          v-hasRole="['ROLE_ADMIN', 'ROLE_SUPER_ADMIN']">删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain icon="Download" @click="handleExport"
          v-hasRole="['ROLE_ADMIN', 'ROLE_SUPER_ADMIN']">导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="templateList" @selection-change="handleSelectionChange"
      max-height="calc(100vh - 280px)" stripe border>
      <el-table-column type="selection" width="55" align="center" />
      <!-- <el-table-column label="模板主键" width="100" align="center" prop="id" /> -->
      <el-table-column label="模板Key" width="190" prop="tplKey" show-overflow-tooltip />
      <el-table-column label="模板标题" prop="title" :show-overflow-tooltip="true" />
      <el-table-column label="模板语言" width="120" align="center" prop="tplLang" :show-overflow-tooltip="true" />
      <el-table-column label="模板内容" prop="tplContent" :show-overflow-tooltip="true" />
      <el-table-column label="启用状态" width="120" align="center" prop="enabled">
        <template #default="scope">
          <dict-tag :options="sys_enabled_char" :value="scope.row.enabled" />
        </template>
      </el-table-column>
      <el-table-column label="备注" prop="remark" :show-overflow-tooltip="true" />
      <el-table-column label="更新时间" align="center" prop="updateTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.updateTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="150" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)"
            v-hasRole="['ROLE_ADMIN', 'ROLE_SUPER_ADMIN']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)"
            v-hasRole="['ROLE_ADMIN', 'ROLE_SUPER_ADMIN']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize" @pagination="getList" />

    <!-- 添加或修改模板对话框 -->
    <el-dialog :title="title" v-model="open" width="680px" append-to-body>
      <el-form ref="templateRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="模板Key" prop="tplKey" :error="erorMessage">
          <el-input v-model="form.tplKey" :disabled="form.id" placeholder="请输入模板标题" />
        </el-form-item>
        <el-form-item label="模板标题" prop="title">
          <el-input v-model="form.title" placeholder="请输入模板标题" />
        </el-form-item>
        <el-form-item label="模板语言" prop="tplLang">
          <el-input v-model="form.tplLang" placeholder="请输入模板语言" />
        </el-form-item>
        <el-form-item label="模板内容" prop="tplContent">
          <el-input v-model="form.tplContent" placeholder="请输入模板内容" type="textarea" rows="10" maxlength="10240000" />
        </el-form-item>
        <el-form-item label="启用状态" prop="enabled">
          <el-radio-group v-model="form.enabled">
            <el-radio v-for="dict in sys_enabled_char" :key="dict.value" :value="dict.value">{{ dict.label
            }}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入内容" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="sysTpl">
import { listTemplate, getTemplate, delTemplate, addTemplate, updateTemplate } from '@/api/system/template'

const { proxy } = getCurrentInstance()
const { sys_enabled_char } = proxy.useDict('sys_enabled_char')

const templateList = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref('')
const dateRange = ref([])
const erorMessage = ref('')

const data = reactive({
  form: {
    enabled: 'Y'
  },
  queryParams: {
    pageNum: 1,
    pageSize: 20,
    tplKey: undefined,
    title: undefined,
    tplLang: undefined,
    enabled: undefined
  },
  rules: {
    tplKey: [{ required: true, message: '模板Key不能为空', trigger: 'blur' }],
    title: [{ required: true, message: '模板标题不能为空', trigger: 'blur' }],
    tplLang: [{ required: true, message: '模板语言不能为空', trigger: 'blur' }],
    tplContent: [{ required: true, message: '模板内容不能为空', trigger: 'blur' }]
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 查询模板列表 */
function getList() {
  loading.value = true
  listTemplate(proxy.addDateRange(queryParams.value, dateRange.value)).then(({ data }) => {
    templateList.value = data.records
    total.value = data.totalRow
    loading.value = false
  })
}

/** 取消按钮 */
function cancel() {
  open.value = false
  reset()
}

/** 表单重置 */
function reset() {
  form.value = {
    id: undefined,
    title: undefined,
    tplLang: undefined,
    tplContent: undefined,
    enabled: 'Y',
    remark: undefined
  }
  proxy.resetForm('templateRef')
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

/** 重置按钮操作 */
function resetQuery() {
  dateRange.value = []
  proxy.resetForm('queryRef')
  handleQuery()
}

/** 多选框选中数据 */
function handleSelectionChange(selection) {
  ids.value = selection.map((item) => item.id)
  single.value = selection.length != 1
  multiple.value = !selection.length
}

/** 新增按钮操作 */
function handleAdd() {
  reset()
  open.value = true
  title.value = '添加模板'
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const id = row.id || ids.value
  getTemplate(id).then((response) => {
    form.value = response.data
    open.value = true
    title.value = '修改模板'
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs['templateRef'].validate((valid) => {
    if (valid) {
      if (form.value.id != undefined) {
        updateTemplate(form.value).then((response) => {
          proxy.$modal.msgSuccess('修改成功')
          open.value = false
          getList()
        })
      } else {
        addTemplate(form.value).then(({ data, status, message }) => {
          if (status === 200) {
            proxy.$modal.msgSuccess('新增成功')
            open.value = false
            getList()
          } else {
            erorMessage.value = message
          }
        })
      }
    }
  })
}

/** 删除按钮操作 */
function handleDelete(row) {
  const delIds = row.id || ids.value
  proxy.$modal
    .confirm('是否确认删除模板编号为"' + delIds + '"的数据项？')
    .then(function () {
      return delTemplate(delIds)
    })
    .then(() => {
      getList()
      proxy.$modal.msgSuccess('删除成功')
    })
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download(
    'system/template/export',
    {
      ...queryParams.value
    },
    `template_${new Date().getTime()}.xlsx`
  )
}

getList()
</script>
